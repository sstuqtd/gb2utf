require 'iconv'
require 'fileutils'

class File
  def self.binary?(name)
    myStat = stat(name)
    return false unless myStat.file?
    open(name) { |file|
      return false if file.size == 0
      blk = file.read(myStat.blksize)
      return blk.size == 0 ||
          blk.count("^ -~", "^\r\n") / blk.size > 0.3 ||
          blk.count("\x00") > 0
    }
  end
end

class Gb2utf

  attr_accessor :from, :to
  attr_accessor :src_dir, :dst_dir
  attr_accessor :ic

  def initialize

  end

  def convert(from, to, dir)

    halt("#{@src_dir} does not exists") unless File.directory?(dir)

    case from
    when 'GB'
      @from = 'GB18030'
    when 'UTF'
      @from = 'UTF-8'
    end

    case to
    when 'GB'
      @to = 'GB18030'
    when 'UTF'
      @to = 'UTF-8'
    end

    # src_dir 是可以相对于当前目录的任意一个目录形式
    @src_dir = File.expand_path(dir)
    # dst_dir 是相对于当前目录的
    @dst_dir = "#{@src_dir}.#{to.upcase}"

    FileUtils.cp_r(@src_dir, @dst_dir)

    @ic = Iconv.open("#{@to}//IGNORE", @from)

    Dir.chdir("#{@src_dir}")
    Dir.foreach('.') { |f|
      next if ['.', '..'].include?(f)
      if File.directory?(f)
        convert_dir(f)
      else
        convert_file(f)
      end
    }

  end

  private

  def halt(msg)
    $stderr.puts msg
    exit 1
  end

  def convert_dir(dir)
    dst_dir = "#{@dst_dir}/#{dir}"
    FileUtils.mkdir_p(dst_dir)
    Dir.foreach(dir) { |f|
      next if ['.', '..'].include?(f)
      ff = "#{dir}/#{f}"
      if File.directory?(ff)
        convert_dir(ff)
      else
        convert_file(ff)
      end
    }
  end

  def convert_file(file)
    $stderr.puts file
    src_file = "#{@src_dir}/#{file}"
    dst_file = "#{@dst_dir}/#{file}"
    return if File.lstat(src_file).symlink? or File.binary?(src_file)
    orig = File.open(src_file, 'r') { |f| f.read }
    begin
      dest = @ic.iconv(orig)
      File.open(dst_file, 'w') { |f| f.write(dest) }
    rescue
      $stderr.puts "... IGNORED"
    end
  end

end
