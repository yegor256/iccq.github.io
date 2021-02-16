require 'time'

dir = ARGV[0]

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

File.readlines(File.join(dir, 'book.toc')).each do |t|
  next unless t.start_with?('\contentsline {section}')
  m = t.scan(/\{([^\}]+)\}*/)
  title = m[1][0].strip
  page = m[2][0].strip.to_i
  `pdfseparate #{File.join(dir, 'book.pdf')} -f #{page} -l #{page} %d.pdf`
  fname = format('%02d-%s.pdf', page, title.downcase.gsub(/[^a-z]/, '-'))
  File.rename("#{page}.pdf", fname)
  lines << [
    'Y',
    page,
    'front-cover',
    'N',
    'X',
    'NA'
  ].join("\t")
end

lines << ''

File.write('package.txt', lines.join("\n"))

