class BucketsController < ApplicationController
  before_action :require_login

  def index
  	@buckets = Bucket.page param_page
  end

  def show
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if params[:id].nil?
  	@bucket = Bucket.find_by(id: params[:id])
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if @bucket.nil?
  end

  def new
  end

  def create
  	bucket = Bucket.new bucket_params
    return redirect_back_data_error new_user_path, "Data tidak valid!" if bucket.invalid?
    bucket.save!
    bucket.create_activity :create, owner: current_user
    return redirect_success bucket_path(id: bucket.id), "Jenis Emas berhasil ditambahkan"
  end

  def destroy
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if params[:id].nil?
  	bucket = Bucket.find_by(id: params[:id])
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if bucket.nil?
  	return redirect_back_data_error buckets_path, "Data tidak dapat dihapus" if bucket.items.count > 0
  	bucket_name = bucket.name
  	bucket.destroy
  	return redirect_success buckets_path, "Data Baki - " + bucket_name + " berhasil dihapus"
  end

  def edit
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if params[:id].nil?
  	@bucket = Bucket.find_by(id: params[:id])
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if @bucket.nil?
  end

  def update
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if params[:id].nil?
  	bucket = Bucket.find_by(id: params[:id])
  	return redirect_back_data_error buckets_path, "Data tidak ditemukan" if bucket.nil?
  	bucket.assign_attributes bucket_params
  	changes = bucket.changes
    bucket.save! if bucket.changed?
    bucket.create_activity :edit, owner: current_user, parameters: changes
    return redirect_success bucket_path(id: bucket.id), "Data Jenis Emas - " + bucket.name + " - Berhasil Diubah"

  end

  private
    def bucket_params
      params.require(:bucket).permit(
        :name
      )
    end

    def param_page
      params[:page]
    end
end