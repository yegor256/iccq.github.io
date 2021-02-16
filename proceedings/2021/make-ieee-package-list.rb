require 'time'
require 'fileutils'

dir = ARGV[0]

items = []

FileUtils.cp(File.join(dir, 'cover.pdf'), 'cover.pdf')
items << { file: 'cover.pdf', type: 'front-cover', ecf: 'NA', ecf_id: '' }

File.readlines(File.join(dir, 'book.toc')).each do |t|
  next unless t.start_with?('\contentsline {section}')
  m = t.scan(/\{([^\}]+)\}*/)
  title = m[1][0].strip
  page = m[2][0].strip.to_i
  `pdfseparate #{File.join(dir, 'book.pdf')} -f #{page} -l #{page} %d.pdf`
  fname = format('%s.pdf', title.downcase.gsub(/[^a-z]/, '-'))
  File.rename("#{page}.pdf", fname)
  type = 'commentary'
  type = 'toc' if fname.include?('contents')
  type = 'index-author' if fname.include?('author-index')
  items << { file: fname, type: type, ecf: 'NA', ecf_id: '' }
end

Dir[File.join(dir, 'papers/*.pdf')].each_with_index do |f, i|
  pid = f.gsub(/^.+\/(\d\d)\.pdf$/, '\1')
  tex = File.readlines(File.join(dir, 'book.tex')).select { |t| t.start_with? ("\\paper{#{pid}}") }.first
  m = tex.scan(/([A-Z]+)=([^,]+)/)
  fname = format('paper-%d.pdf', i)
  FileUtils.cp(f, fname)
  items << {
    file: fname,
    type: 'orig-research',
    ecf: 'Y',
    ecf_id: m.select { |p| p[0] == 'ECF' }.first[1].strip
  }
end

items.each_with_index do |item, idx|
  fname = format('%02d-%s', idx + 1, item[:file])
  File.rename(item[:file], fname)
  item[:file] = fname
  item[:index] = idx + 1
end

lines = [
  "3\t1.7",
  'Yegor Bugayenko',
  'yegor256@gmail.com',
  '+79855806546',
  'ICCQ 2021',
  'Moscow, Russia',
  "2020-03-27 2020-03-27\n",
  'Final',
  File.read(File.join(dir, 'ieee-record.txt')),
  "#{File.read(File.join(dir, 'issn.txt'))} Electronic",
  "#{File.read(File.join(dir, 'isbn.txt'))} Electronic\n\n"
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

File.write('package.txt', lines.join("\n") + "\n")
