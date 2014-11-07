# Checks what OS the user is on
module OS
  class << self
    def windows?
      !!(RUBY_PLATFORM.match(/cygwin|mswin|mingw|bccwin|wince|emx/))
    end

    def mac?
      !!(RUBY_PLATFORM.match(/darwin/))
    end

    def linux?
      not mac? and not windows?
    end
  end
end
