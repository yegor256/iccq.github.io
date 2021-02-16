require 'time'
require 'fileutils'

dir = ARGV[0]

items = []

FileUtils.cp(File.join(dir, 'cover.pdf'), 'cover.pdf')
items << { file: 'cover.pdf', type: 'front-cover' }

File.readlines(File.join(dir, 'book.toc')).each do |t|
  next unless t.start_with?('\contentsline {section}')
  m = t.scan(/\{([^\}]+)\}*/)
  title = m[1][0].strip
  page = m[2][0].strip.to_i
  `pdfseparate #{File.join(dir, 'book.pdf')} -f #{page} -l #{page} %d.pdf`
  fname = format('%s.pdf', title.downcase.gsub(/[^a-z]/, '-'))
  File.rename("#{page}.pdf", fname)
  items << { file: fname, type: 'supp' }
end

Dir[File.join(dir, 'papers/*.pdf')].each_with_index do |f, i|
  fname = format('paper-%d.pdf', i)
  FileUtils.cp(f, fname)
  items << { file: fname, type: 'paper' }
end

items.each_with_index do |item, idx|
  fname = format('%02d-%s', idx, item[:file])
  File.rename(item[:file], fname)
  item[:file] = fname
end

lines = [
  "3\t1.17",
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
    '1',
    i[:type],
    'N',
    'X',
    'NA'
  ].join("\t")
end

File.write('package.txt', lines.join("\n") + "\n")
