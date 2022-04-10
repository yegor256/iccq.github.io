require 'time'
require 'fileutils'

dir = ARGV[0]

items = []

def exec(cmd)
  puts "+ #{cmd}"
  out = `#{cmd}`
  puts '> ' + out.strip.gsub("\n", "\n> ") unless out.empty?
  out
end

exec("pdfcrop --margins '-790 0 0 0' #{File.join(dir, 'cover.pdf')} cover.pdf")
items << { file: 'cover.pdf', type: 'front-cover', ecf: 'NA', ecf_id: '' }

File.readlines(File.join(dir, 'book.toc')).each do |t|
  next unless t.start_with?('\contentsline {section}')
  m = t.scan(/\{([^\}]+)\}*/)
  title = m[1][0].strip
  page = m[2][0].strip.to_i
  exec("pdfseparate #{File.join(dir, 'book.pdf')} -f #{page} -l #{page} %d.pdf")
  fname = format('%s.pdf', title.downcase.gsub(/[^a-z]/, '-'))
  File.rename("#{page}.pdf", fname)
  type = 'commentary'
  type = 'toc' if fname.include?('contents')
  type = 'index-author' if fname.include?('author-index')
  items << { file: fname, type: type, ecf: 'NA', ecf_id: '' }
end

File.readlines(File.join(dir, 'book.pages')).each do |t|
  pid, first, last = t.strip.split('-')
  first = first.to_i
  last = last.to_i - 1
  exec("pdfseparate #{File.join(dir, 'book.pdf')} -f #{first} -l #{last} %d.pdf")
  fname = "research-paper-#{pid}.pdf"
  exec("qpdf --min-version=1.5 --empty --pages #{(first..last).map { |p| "#{p}.pdf" }.join(' ')} -- #{fname}")
  unless exec("file #{fname}").include?('version 1.5')
    raise 'qpdf produced incorrect version'
  end
  (first..last).each { |p| FileUtils.rm("#{p}.pdf") }
  items << {
    file: fname,
    type: 'orig-research',
    ecf: 'Y',
    ecf_id: pid
  }
end

items.each_with_index do |item, idx|
  fname = format('%02d-%s', idx + 1, item[:file])
  File.rename(item[:file], fname)
  exec("exiftool -overwrite_original -Creator='Certified by IEEE PDFeXpress at #{Time.now.strftime("%B %-d, %Y %H:%M:%S")}' #{fname}")
  item[:file] = fname
  item[:index] = idx + 1
end

lines = [
  "3\t1.7",
  'Yegor Bugayenko',
  'yegor256@gmail.com',
  '+79855806546',
  'ICCQ 2022',
  'Moscow, Russia',
  "2020-03-27 2020-03-27\r\n",
  'Final',
  File.read(File.join(dir, 'ieee-record.txt')),
  "#{File.read(File.join(dir, 'issn.txt'))} Electronic",
  "#{File.read(File.join(dir, 'isbn.txt'))} Electronic\r\n\r\n"
]

lines += items.map do |i|
  [
    i[:file],
    'Y',
    i[:index],
    i[:type],
    '',
    '',
    'N',
    'X',
    i[:ecf_id],
    i[:ecf]
  ].join("\t")
end

File.write('package.txt', lines.join("\r\n") + "\r\n")
