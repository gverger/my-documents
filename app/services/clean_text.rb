class CleanText
  attr_reader :text
  def initialize(text)
    @text = text
  end

  def call
    text
      .gsub(/[^[:alnum:],."'\n]/, ' ')
      .gsub(/[^\S\r\n]+/, ' ')
      .gsub(/^\s$/, '')
      .gsub(/\n+/, "\n")
      .delete("\u0000")
  end
end
