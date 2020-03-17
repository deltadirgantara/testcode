class ItemsController < ApplicationController
  before_action :require_login

  def index
  	@items = Item.page param_page
  end

  def show
  	return redirect_back_data_error items_path, "Data tidak ditemukan" if params[:id].nil?
  	@item = Item.find_by(id: params[:id])
  	return redirect_back_data_error items_path, "Data tidak ditemukan" if @item.nil?
  end

  def new
    @categories = Category.all.order("name ASC")
    @gold_types = GoldType.all.order("name ASC")
    @buckets = Bucket.all.order("name ASC")
  end

  def create
  	item = Item.new item_params
    item.store = current_user.store
    item.stock = 1
    if item.code == ""
      item.code = item.gold_type.id.to_s+"/"+item.sub_category.id.to_s+"/"+item.bucket.id.to_s+"/"+DateTime.now.to_i.to_s
    end
    file = params[:item][:image]
    upload_io = params[:item][:image]
    if file.present?
      filename = Digest::SHA1.hexdigest([Time.now, rand].join).to_s+File.extname(file.path).to_s
      File.open(Rails.root.join('public', 'uploads', 'items', filename), 'wb') do |file|
        file.write(upload_io.read)
      end
      item.image = filename
    end
    item.save!
    item.create_activity :create, owner: current_user
    return redirect_success item_path(id: item.id), "Barang - " + item.code + " berhasil disimpan"
  end

  def destroy
  	return redirect_back_data_error items_path, "Data tidak ditemukan" if params[:id].nil?
  	item = Item.find_by(id: params[:id])
  	return redirect_back_data_error items_path, "Data tidak ditemukan" if item.nil?
  	return redirect_back_data_error items_path, "Data tidak dapat dihapus" if item.stock <= 0
  	item_name = item.code
  	item.destroy
  	return redirect_success items_path, "Barang - " + item_name + " berhasil dihapus"
  end

  def edit
  	return redirect_back_data_error items_path, "Data tidak ditemukan" if params[:id].nil?
  	@item = Item.find_by(id: params[:id])
  	return redirect_back_data_error items_path, "Data tidak ditemukan" if @item.nil?
    @categories = Category.all.order("name ASC")
    @gold_types = GoldType.all.order("name ASC")
    @buckets = Bucket.all.order("name ASC")
  end

  def update
  	return redirect_back_data_error items_path, "Data tidak ditemukan" if params[:id].nil?
  	item = Item.find_by(id: params[:id])
  	return redirect_back_data_error items_path, "Data tidak ditemukan" if item.nil?
  	item.assign_attributes item_params
    file = params[:item][:image]
    upload_io = params[:item][:image]
    if file.present?
      filename = Digest::SHA1.hexdigest([Time.now, rand].join).to_s+File.extname(file.path).to_s
      File.open(Rails.root.join('public', 'uploads', 'items', filename), 'wb') do |file|
        file.write(upload_io.read)
      end
      item.image = filename
    end
  	changes = item.changes
    item.save! if item.changed?
    item.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success item_path(id: item.id), "Barang - " + item.code + " - Berhasil Diubah"

  end

  private
    def item_params
      params.require(:item).permit(
        :code, :weight, :sub_category_id, :gold_type_id, :bucket_id, :buy, :image
      )
    end

    def param_page
      params[:page]
    end
end