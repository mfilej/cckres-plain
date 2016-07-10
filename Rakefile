require "bundler/setup"

KRES_URL = "https://www.clarin.si/repository/xmlui/bitstream/handle/11356/1034/cckresV1_0.zip?sequence=1&isAllowed=y"
TEITOMARKDOWN = "./TEIC-Stylesheets/bin/teitomarkdown"

namespace :kres do
  desc "Download and extract ccKres corpus into <dest_dir>."
  task :download, [:dest_dir] do |_t, args|
    abort "Please specify destination directory." unless args.dest_dir
    abort "Destination already exists, aborting." if File.exist?(args.dest_dir)

    dest_dir = File.expand_path(args.dest_dir)

    Dir.mktmpdir do |tmp_dir|
      cd tmp_dir do
        sh "curl", "-s", "-occkres.zip", KRES_URL
        sh "unzip", "-q", "-dkres", "cckres.zip"
        mv "kres", dest_dir
      end
    end
  end

  desc "Extract corpus plain text from TEI files located in <dir>." << <<-DESC

    Parallelize using <cores> number of cores. If not provided the program
    will use the number of cores reported by the system. On systems with
    hyper-threading you might want to make sure you specify the number of
    physical cores.
  DESC
  task :extract, [:dir, :cores] do |_t, args|
    abort "Please specify directory." unless args.dir
    abort "Directory does not exist." unless File.directory? args.dir

    cores = args.cores || begin
      require "etc"
      Etc.nprocessors.to_s
    end

    sh "find #{args.dir} -iname \"*.xml\" | xargs -n1 -P8 #{TEITOMARKDOWN}"
  end

  desc "Sorts and names corpus files according to their type." << <<-DESC

  Assumes `kres:extract` task has already been run, causing each .xml file in
  <src_dir> to have a matching .xml.markdown file. Markdown files will be
  named and sorted into subdirectories of <dest_dir> according to the
  information contained in the .xml files.
  DESC
  task :sort, [:src_dir, :dest_dir] do |_t, args|
    abort "Please specify source directory." unless args.src_dir
    abort "Please specify destination directory." unless args.dest_dir
    abort "Source directory does not exist." unless File.directory? args.src_dir

    mkdir_p args.dest_dir

    require "bundler/setup"
    require "nokogiri"
    require "babosa"
    require "progress"

    xml_files = File.join(args.src_dir, "**/*.xml")

    Pathname.glob(xml_files).with_progress.map do |file|
      File.open(file) do |f|
        doc = Nokogiri::XML(f)
        doc.remove_namespaces!
        name = doc.xpath("//sourceDesc/bibl/title").text
        name.strip!
        name = name.to_slug.normalize.to_s

        id = file.basename(".xml").to_s

        target_file_name = "#{id}-#{name}.txt"

        target_dir = doc.xpath("//profileDesc/textClass/catRef").attr("target").value
        target_dir.tr! "#", ""
        target_dir.tr! ".", "/"

        target_dir = File.join(args.dest_dir, target_dir)
        target = File.join(target_dir, target_file_name)

        verbose false do
          mkdir_p(target_dir)
          cp(file.sub_ext(".xml.markdown"), target)
        end
      end
    end
  end
end
