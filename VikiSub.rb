# VikiSub VERSION 0.1
#!/usr/bin/env ruby
require 'json'


class VikiSubConv
  attr_accessor :jsonfile, :parsedJson, :convTime

  # constructor
  def initialize(jsonfile)
    if File.exist?(jsonfile)
		@jsonfile = jsonfile
		@parsedJson = nil
	else
		puts "The JSON file does not exist!"
		abort
	end
  end

  def ParseSub
    if @jsonfile.nil? or @jsonfile == ""
      puts "No json file provided"
    else
      @parsedJson = JSON.parse(File.read(@jsonfile))
    end
  end

  def WriteSRT(outfile)
	if File.exist?(outfile)
		puts "This file already exists!"
		abort
	else
		srt = ""
		@parsedJson["subtitles"].each_with_index {|line,i|
		  srt += "#{i}\n"
		  srt += ConvertMStoTime(line['start_time']) + " --> " + ConvertMStoTime(line['end_time']) + "\n"
		  srt += "#{line['content']}\n\n"
		}
		out = File.new(outfile, 'w')
		out.puts srt
		out.close
	end
  end

  def ConvertMStoTime(msecs)
    hours = msecs / 3600000
    msecs -= hours * 3600000
    mins = msecs / 60000
    msecs -= mins * 60000
    seconds = msecs / 1000
    msecs -= seconds * 1000
    return sprintf("%02d",hours) + ":" + sprintf("%02d",mins) + ":" + sprintf("%02d",seconds) + "," + sprintf("%03d",msecs)
  end
end

(0..ARGV.length-1).step(2) {|i|
  vc = VikiSubConv.new(ARGV[i])
  vc.ParseSub()
  vc.WriteSRT(ARGV[i+1])
}