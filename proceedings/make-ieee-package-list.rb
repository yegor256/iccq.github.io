# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Once ready, send it here: https://mft.ieee.org/conferences_events/ConfPubFileUploadUI/

require 'time'
require 'fileutils'

dir = File.expand_path(ARGV[0])

year = ARGV[1].nil? ? Time.new.year : ARGV[1].to_i

items = []

def exec(cmd)
  puts "+ #{cmd}"
  out = `#{cmd}`
  puts '> ' + out.strip.gsub("\n", "\n> ") unless out.empty?
  out
end

width = exec("identify -verbose #{File.join(dir, 'cover.pdf')} | grep 'geometry' | sed -E 's/[^0-9]/ /g' | xargs | cut -f1 -d' '").strip.to_i
exec("pdfcrop --margins '-#{width / 2 + 50} 0 0 0' #{File.join(dir, 'cover.pdf')} cover.pdf")
items << { file: 'cover.pdf', type: 'front-cover', ecf: 'NA', ecf_id: '' }

pages = {}
File.readlines(File.join(dir, 'book.pages')).each do |t|
  pid, pg = t.strip.split(':')
  first, last = pg.split('-')
  first = first.to_i
  last = last.to_i
  pages[pid] = { first: first, last: last }
end

File.readlines(File.join(dir, 'book.toc')).each do |t|
  next unless t.start_with?('\contentsline {section}')
  m = t.scan(/\{([^\}]+)\}*/)
  title = m[1][0].strip
  first = m[2][0].strip.to_i
  tail = pages.values.find { |p| p[:first] == first }
  last = tail.nil? ? first : tail[:last]
  exec("pdfseparate #{File.join(dir, 'book.pdf')} -f #{first} -l #{last} %d.pdf")
  fname = format('%s.pdf', title.downcase.gsub(/[^a-z]/, '-').gsub(/--/, '-'))
  exec("qpdf --min-version=1.5 --empty --pages #{(first..last).map { |p| "#{p}.pdf" }.join(' ')} -- #{fname}")
  (first..last).each { |p| FileUtils.rm("#{p}.pdf") }
  type = 'commentary'
  type = 'toc' if fname.include?('contents')
  type = 'index-author' if fname.include?('author-index')
  items << { file: fname, type: type, ecf: 'NA', ecf_id: '' }
end

pages.each do |pg|
  pid = pg[0]
  next unless pid =~ /^[0-9]+$/
  first = pg[1][:first]
  last = pg[1][:last]
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

date = File.read(File.join(dir, 'date.txt')).strip

lines = [
  "3\t1.7",
  'Yegor Bugayenko',
  'yegor256@gmail.com',
  '+79855806546',
  "ICCQ #{year}",
  'Moscow, Russia',
  "#{date} #{date}\r\n",
  'Final',
  File.read(File.join(dir, 'ieee-record.txt')).strip,
  "#{File.read(File.join(dir, 'issn.txt')).strip} Electronic",
  "#{File.read(File.join(dir, 'isbn.txt')).strip} Electronic\r\n\r\n"
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
