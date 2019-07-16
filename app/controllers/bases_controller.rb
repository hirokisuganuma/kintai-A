class BasesController < ApplicationController
  
  def base_edit
    @bases = Base.all
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
      if @base.save
        flash[:success] = "拠点情報を追加しました。"
        redirect_to base_edit_bases_path
      else
        render 'base_edit'
      end
  end
  
  def base_update
    @base = Base.find(params[:id])
      if @base.update(base_params)
        flash[:success] = "拠点情報を更新しました。"
        redirect_to base_edit_bases_path
      else
        render 'base_edit'
      end
  end
  
  def base_delete
    @base = Base.find(params[:id])
      if @base.destroy
        flash[:danger] = "拠点情報を削除しました。"
        redirect_to base_edit_bases_path
      else
        render 'base_edit'
      end
  end
  
  def base_edit_modal
    @base = Base.find(params[:id])
  end
  
private
    def base_params
      params.require(:base).permit(:number, :name, :kind)
    end
end