require 'tweetstream'
require 'sentimental'
require 'serialport'



#params for serial port
port_str = "/dev/tty.usbmodem1441"  #may be different for you
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

# Load the default sentiment dictionaries
Sentimental.load_defaults
# Set a global threshold
Sentimental.threshold = 0.1
# Create an instance for usage:
analyzer = Sentimental.new

hashtag = "#mooduino";

#Fill with API keys
TweetStream.configure do |config|
  config.consumer_key       = ""
  config.consumer_secret    = ""
  config.oauth_token        = ""
  config.oauth_token_secret = ""
  config.auth_method        = :oauth
end



# Pull all tweets with the hashtag #mooduino
TweetStream::Client.new.track("#mooduino") do |status|


  puts "#{status.text}"
  puts analyzer.get_sentiment status.text
  puts analyzer.get_score status.text


  score = analyzer.get_score status.text

  signal = 0xff;
  sp.putc(signal)

  # min = 100 (Blue)
  # max = 250 (Red, orangish)
  hue = 175 + score * 75

  # Always with full saturation
  saturation = 255

  # min = 65
  # max = 255
  value = 160 + score * 95

  puts "Sending H:#{hue} S:#{saturation} V:#{value}\n"

  sp.putc(hue)
  sp.putc(saturation)
  sp.putc(value)

  sleep(10)

end


TweetStream.on_limit do |skip_count|
  # Twitter streaming API limit reached
  puts "Limit reached"

end
