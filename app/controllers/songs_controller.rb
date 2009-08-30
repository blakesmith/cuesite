class SongsController < ApplicationController

  def show
    @song = Song.find(params[:id])
    @remixes = @song.all_remixes
  end

  def update
    respond_to do |format|
      format.js do
        render :update do |page|
          @song = Song.find(params[:id])
          @song.performer = params[:song][:performer]
          @song.title = params[:song][:title]
          @track = Track.find(params[:track])
          if @song.save
            page.replace "song_#{params[:id]}", :partial => 'cuesheets/song_row', :object => @track
            page.hide "edit_song_#{params[:id]}"
            page.show "display_song_#{params[:id]}"
          end
        end
      end
    end
  end

end
