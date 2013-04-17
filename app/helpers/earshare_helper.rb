module EarshareHelper
  class Stats
    def get_artists
      file = open("http://ws.audioscrobbler.com/2.0/?method=user.getartisttracks&user=rj&artist=metallica&api_key=74cac458c3a4e1a609ec88017afe2be2")
      @artists = JSON.load(file.read)
    end
  end
end
