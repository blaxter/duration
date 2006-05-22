# = Author
#
# Matthew Harris (mailto:shugotenshi@gmail.com)
#
# = Project
#
# http://www.rubyforge.org/projects/duration
#
# = Synopsis
#
# Duration is a simple class that provides ways of easily manipulating durations
# (timespans) and formatting them as well.
#
# = Usage
#
# 	require 'duration'
# 	=> true
# 	d = Duration.new(60 * 60 * 24 * 10 + 120 + 30)
# 	=> #<Duration: 1 week, 3 days, 2 minutes and 30 seconds>
# 	d.to_s
# 	=> "1 week, 3 days, 2 minutes and 30 seconds"
# 	[d.weeks, d.days]
# 	=> [1, 3]
# 	d.days = 7; d
# 	=> #<Duration: 2 weeks, 2 minutes and 30 seconds>
# 	d.strftime('%w w, %d d, %h h, %m m, %s s')
# 	=> "2 w, 0 d, 0 h, 2 m, 30 s"
#
class Duration
	attr_reader :total, :weeks, :days, :hours, :minutes, :seconds

	WEEK    =  60 * 60 * 24 * 7
	DAY     =  60 * 60 * 24
	HOUR    =  60 * 60
	MINUTE  =  60
	SECOND  =  1

	# Initialize Duration class.
	#
	# *Example*
	#
	# 	d = Duration.new(60 * 60 * 24 * 10 + 120 + 30)
	# 	=> #<Duration: 1 week, 3 days, 2 minutes and 30 seconds>
	#
	# 	d = Duration.new(:weeks => 1, :days => 3, :minutes => 2, :seconds => 30)
	# 	=> #<Duration: 1 week, 3 days, 2 minutes and 30 seconds>
	#
	def initialize(seconds_or_attr)
		if (h = seconds_or_attr).kind_of? Hash
			seconds =  0
			seconds += h[:weeks]   * WEEK   if h.key? :weeks
			seconds += h[:days]    * DAY    if h.key? :days
			seconds += h[:hours]   * HOUR   if h.key? :hours
			seconds += h[:minutes] * MINUTE if h.key? :minutes
			seconds += h[:seconds] * SECOND if h.key? :seconds
		else
			seconds = seconds_or_attr
		end

		@total, array = seconds.to_f.round, []
		@seconds = [WEEK, DAY, HOUR, MINUTE].inject(@total) do |left, part|
			array << left / part; left % part
		end

		@weeks, @days, @hours, @minutes = array
	end

	# Format duration.
	#
	# *Identifiers*
	#
	# 	%w - Number of weeks
	# 	%d - Number of days
	# 	%h - Number of hours
	# 	%m - Number of minutes
	# 	%s - Number of seconds
	# 	%% - Literal `%' character
	#
	# *Example*
	#
	# 	d = Duration.new(:weeks => 10, :days => 7)
	# 	=> #<Duration: 11 weeks>
	# 	d.strftime("It's been %w weeks!")
	# 	=> "It's been 11 weeks!"
	#
	def strftime(fmt)
		h =\
		{'w' => @weeks  ,
		 'd' => @days   ,
		 'h' => @hours  ,
		 'm' => @minutes,
		 's' => @seconds}

		fmt.gsub(/%?%(w|d|h|m|s)/) do |match|
			match.size == 3 ? match : h[match[1..1]]
		end.gsub('%%', '%')
	end

	# Intercept certain attribute writers. Intercepts `weeks=', `days=', `hours=',
	# `minutes=', `seconds=', and `total='
	#
	# *Example*
	#
	# 	d = Duration.new(:days => 6)
	# 	=> #<Duration: 6 days>
	# 	d.days += 1; d
	# 	=> #<Duration: 1 week>
	#
	def method_missing(method, *args)
		case method
		when :weeks=   then initialize(WEEK   * args[0] + (@total - WEEK   * @weeks  ))
		when :days=    then initialize(DAY    * args[0] + (@total - DAY    * @days   ))
		when :hours=   then initialize(HOUR   * args[0] + (@total - HOUR   * @hours  ))
		when :minutes= then initialize(MINUTE * args[0] + (@total - MINUTE * @minutes))
		when :seconds= then initialize(SECOND * args[0] + (@total - SECOND * @seconds))
		when :total=   then initialize(args[0])
		else
			raise NoMethodError, "undefined method `#{method}' for #{inspect}"
		end
	end

	# Friendly, human-readable string representation of the duration.
	#
	# *Example*
	#
	# 	d = Duration.new(:seconds => 140)
	# 	=> #<Duration: 2 minutes and 20 seconds>
	# 	d.to_s
	# 	=> "2 minutes and 20 seconds"
	#
	def to_s
		str = ''

		[['weeks'   ,  @weeks  ],
		 ['days'    ,  @days   ],
		 ['hours'   ,  @hours  ],
		 ['minutes' ,  @minutes],
		 ['seconds' ,  @seconds]].each do |part, time|

			# Skip any zero times.
			next if time.zero?

			# Concatenate the part of the time and the time itself.
			str << "#{time} #{time == 1 ? part[0..-2] : part}, "
		end

		str.chomp(', ').sub(/(.+), (.+)/, '\1 and \2')
	end

	# Inspection string--Similar to #to_s except that it has the class name.
	#
	# *Example*
	#
	# 	Duration.new(:seconds => 140)
	# 	=> #<Duration: 2 minutes and 20 seconds>
	#
	def inspect
		"#<#{self.class}: #{(s = to_s).empty? ? '...' : s}>"
	end

	# Add to Duration.
	#
	# *Example*
	#
	# 	d = Duration.new(30)
	# 	=> #<Duration: 30 seconds>
	# 	d + 30
	# 	=> #<Duration: 1 minute>
	#
	def +(other)
		self.class.new(@total + other.to_i)
	end

	# Subtract from Duration.
	#
	# *Example*
	#
	# 	d = Duration.new(30)
	# 	=> #<Duration: 30 seconds>
	# 	d - 15
	# 	=> #<Duration: 15 seconds>
	#
	def -(other)
		self.class.new(@total - other.to_i)
	end

	# Multiply two Durations.
	#
	# *Example*
	#
	# 	d = Duration.new(30)
	# 	=> #<Duration: 30 seconds>
	# 	d * 2
	# 	=> #<Duration: 1 minute>
	#
	def *(other)
		self.class.new(@total * other.to_i)
	end

	# Divide two Durations.
	#
	# *Example*
	#
	# 	d = Duration.new(30)
	# 	=> #<Duration: 30 seconds>
	# 	d / 2
	# 	=> #<Duration: 15 seconds>
	#
	def /(other)
		self.class.new(@total / other.to_i)
	end

	alias to_i total
end

class Numeric
	alias __Numeric_method_missing method_missing

	# Intercept calls to #weeks, #days, #hours, #minutes, #seconds because Rails
	# defines their own methods, so I'd like to prevent any redefining of Rails'
	# methods.
	#
	# *Example*
	#
	# 	140.seconds
	# 	=> #<Duration: 2 minutes and 20 seconds>
	#
	def method_missing(method, *args)
		case method
		when :weeks   then Duration.new(Duration::WEEK   * self)
		when :days    then Duration.new(Duration::DAY    * self)
		when :hours   then Duration.new(Duration::HOUR   * self)
		when :minutes then Duration.new(Duration::MINUTE * self)
		when :seconds then Duration.new(Duration::SECOND * self)
		else
			__Numeric_method_missing(method, *args)
		end
	end
end