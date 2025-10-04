# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @news = News.find_by(date: Date.today)

    unless @news
      news_data = NewsFetcher.new.fetch_daily_news

      @news = if news_data
                News.create(
                  date: Date.today,
                  title: news_data["title"],
                  summary: news_data["summary"]
                )
              else
                News.create(
                  date: Date.today,
                  title: "取得できていないかも",
                  summary: "やっぱ取得できていない"
                )
              end
    end
  end
end
