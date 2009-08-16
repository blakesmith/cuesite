class SongsController < ApplicationController

  def show
    @song = Song.find(params[:id])
  end

  def update
    respond_to do |format|
      format.js do
        render :update do |page|
          song = Song.find(params[:id])
          song.performer = params[:song][:performer]
          song.title = params[:song][:title]
          if song.save
            page.replace_html "display_song_#{params[:id]}", "#{link_to "#{song.performer} - #{song.title}", song_path(song)}"
            page.hide "edit_song_#{params[:id]}"
            page.show "display_song_#{params[:id]}"
          end
        end
      end
    end
  end

end
