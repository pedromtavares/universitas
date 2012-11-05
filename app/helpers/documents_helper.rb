module DocumentsHelper
  def file_size_from_bytes(size)
    in_kb = (size.to_f / 1024)
    in_kb = 1 if in_kb < 1.0
    if in_kb > 1024
      "#{number_with_precision((in_kb / 1024), :precision => 2)} MB"
    else
      "#{in_kb.round} KB"
    end
  end
  
  def document_icon_for(document, small = false, options = {})
    file = case document.extension
      when 'docx'
        'doc'
      when 'xlsx'
        'xls'
      when 'pptx'
        'ppt'
      when 'jpeg'
        'jpg'
      else
        document.extension
    end
    file = small ? "docs/small/#{file}.png" : "docs/#{file}.png"
    image_tag(file, options)
  end
  
  def document_title_for(filter)
   case filter
   when 'my'
     t('documents.my_documents')
   when 'uploaded'
     t('documents.uploaded')
   else
     t('documents.all')
   end
  end
end