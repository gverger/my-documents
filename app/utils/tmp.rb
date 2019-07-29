# This module contains methods to create temporary directories and files
# This will help setting the default tmp dir to not be /tmp in our containers
module Tmp
  module_function

  def dir
    return Dir.mktmpdir(nil, tmp_root_dir) unless block_given?

    Dir.mktmpdir(nil, tmp_root_dir) do |dir|
      yield dir
    end
  end

  def file
    return Tempfile.create('', tmp_root_dir) unless block_given?

    Tempfile.create('', tmp_root_dir) do |file|
      yield file
    end
  end

  def tmp_root_dir
    @tmp_root_dir ||= ENV.fetch('TMP_DIR') { Dir.tmpdir }
  end
end
