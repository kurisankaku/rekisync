# Tag Service.
class TagService
  # Create a tag.
  #
  # @param [String] name the tag name.
  # @return [Tag] tag.
  def create(name)
    Tag.create do |tag|
      tag.name = name.strip
    end
  end

  # Find the tag by the name.
  #
  # @param [String] name the tag name.
  # @return [Tag] tag.
  def find_by_name(name, field = :name)
    Tag.find_by_name(name.strip) || (fail BadRequestError.resource_not_found(field), "Tag not found.")
  end

  # Fetch tag list.
  #
  # @params [ActionController::Parameters] params parameters.
  # @return [ActiveRecord::Relation] tags.
  def search(params)
    if params[:name].present?
      tags = Tag.where("name like '%#{params[:name].strip}%'")
    else
      tags = Tag.all
    end
    paage = params[:page].to_i == 0 ? 1 : params[:page].to_i
    tags.page(params[:page].to_i)
  end
end
