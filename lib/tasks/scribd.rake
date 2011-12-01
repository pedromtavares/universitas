namespace :scribd do
  desc "Converts non-image documents to Scribd by uploading them from their URL"
  task :convert => :environment do
    Document.all.each do |doc|
      if !Document.is_image?(doc.extension) && doc.file.present?
        result = Scribd.new.upload_from_url(doc.file_url)
        if result.present?
          doc.scribd_access_key = result[:access_key]
          doc.scribd_doc_id = result[:doc_id]
          doc.extension = doc.extension
          doc.content_type = MIME::Types.type_for(doc.file_url)
          doc.save
        end
      end
    end
  end
end