xml.instruct!
xml.block do
  xml.id @revision.id
  xml.block_id @block.id
  xml.language_id @block.language.id
  xml.language @block.language.name
  xml.signature @block.signature
  xml.snippet @revision.snippet
  xml.is_private @block.is_private
  xml.created_at @revision.created_at
end