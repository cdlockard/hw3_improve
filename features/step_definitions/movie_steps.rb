# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    #Movie.create!(:title => movie["title"], :rating => movie["rating"], :release_date=> movie["release_date"])
    #p @movie
    #@movie=Movie.new(movie)
    Movie.create(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #flunk "Unimplemented"
  html_text=page.body
  assert html_text.index(e1)<html_text.index(e2)

end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings:(.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings=rating_list.split
  for rating in ratings
    rating=rating.gsub(/[^\w-]/, '')
    if uncheck != 'un'
      check("ratings_"+rating)
    else
      uncheck("ratings_"+rating)
    end
  end

end

When /^(?:|I )press '([^"]*)'$/ do |button|
  if button=='refresh'
    button='ratings_submit'
  end

  click_button(button)
end

Then /^(?:|I )should see the following movies: (.*)/ do |movie_list|
  movies=movie_list.split(',')
  for movie in movies
    movie=movie.delete("'")
    if page.respond_to? :should
      page.should have_content(movie)
    else
      assert page.has_content?(movie)
    end
  end
end


Then /^(?:|I )should not see the following movies: (.*)/ do |movie_list|
  movies=movie_list.split(',')
  for movie in movies
    movie=movie.delete("'")
    if page.respond_to? :should
      page.should have_no_content(movie)
    else
      assert page.has_no_content?(movie)
    end
  end
end

Then /^(?:|I )should see all the movies./ do
  movies=Movie.all

  for movie in movies
    movie=movie.title.delete("'")
    if page.respond_to? :should
      page.should have_content(movie)
    else
      assert page.has_content?(movie)
    end
  end
end



