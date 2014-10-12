require 'rubygems'
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://google.com/')
google_form = page.form('f')
google_form.q = 'paul koski'
page = agent.submit(google_form)
pp page
