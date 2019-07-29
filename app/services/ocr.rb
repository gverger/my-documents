class Ocr
  attr_reader :image_file
  def initialize(image_file)
    @image_file = image_file
  end

  def call
    Tmp.dir do |dir|
      file = File.join(dir, 'image')
      Command.new("tesseract -l fra+eng #{image_file.path} #{file}").run
      File.read("#{file}.txt")
    end
  end
end
