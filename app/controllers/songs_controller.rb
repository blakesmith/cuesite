class SongsController < ApplicationController

  def show
    @song = Song.find(params[:id])
  end

  def update
    respond_to do |format|
      format.js do
        render :update do |page|
          page.hide "edit_song_#{params[:id]}"
          page.show "display_song_#{params[:id]}"
        end
      end
    end
  end

end
