xml.instruct!
xml.blocks do
  @blocks.each do |block|
    xml.block do
      xml.id block.id
      xml.language_id block.language.id
      xml.language block.language.name
      xml.signature block.signature
      xml.snippet block.latest_revision.snippet
      xml.is_private block.is_private
      xml.created_at block.created_at
    end
  end
end