# frozen_string_literal: true require 'spec_helper' 

require 'spec_helper'

RSpec.describe 'Application', type: :feature do
  before(:example) do
    Capybara.app = Sinatra::Application.new
  end

  it 'Should provide text when connecting to /' do
    visit('/')
    expect(page).to have_content('Flats')
  end

  it 'Should add requests' do
    visit('/add_request')
    fill_in('n_rooms', with: '101')
    fill_in('district', with: 'District #99')
    select('Panel', from: 'hs_type')
    click_on('Add')
    expect(page).to have_content('101')
    expect(page).to have_content('District #99')
    expect(page).to have_content('Panel')
  end

  it 'Should add flat' do
    visit('/add_flat')
    fill_in('square', with: 'ST99999')
    fill_in('n_rooms', with: 'NRT99999')
    fill_in('dist', with: 'T_dist #T')
    fill_in('street', with: 'T_street #T')
    fill_in('n_house', with: 'T_n_house #T')
    fill_in('floor', with: 'FT99999')
    select('Panel', from: 'hs_type')
    fill_in('n_floors', with: 'NFT99999')
    fill_in('price', with: '99999')
    click_on('Add')
    expect(page).to have_content('ST99999')
    expect(page).to have_content('NRT99999')
    expect(page).to have_content('T_dist #T')
    expect(page).to have_content('T_street #T')
    expect(page).to have_content('T_n_house #T')
    expect(page).to have_content('FT99999')
    expect(page).to have_content('Panel')
    expect(page).to have_content('NFT99999')
    expect(page).to have_content('99999')
  end

  it 'Should show statistics' do
    visit('/statistics')
    expect(page).to have_content('Mean square:')
  end

  it 'Should search by district' do
    visit('/show_flats')
    fill_in('dist', with: 'T_dist #T')
    click_on('District search')
    expect(page).to have_content('T_dist #T')
  end

  it 'Should search by price' do
    visit('/show_flats')
    fill_in('range-min', with: '99900') 
    fill_in('range-max', with: '100000') 
    click_on('Price search')
    elem = find_by_id('price-0')
    expect(elem).to have_content('99999') 
  end

  it 'Should find flats according to request' do
    visit('/show_requests')
    find_button('Show flats', match: :first).click
    expect(page).not_to have_content('101')
    expect(page).not_to have_content('District #99')
    expect(page).not_to have_content('Panel')
  end

  it 'Should satisfy request' do
    visit('/show_requests')
    find_button('Show flats', match: :first).click
    # I need to get all info from the page 
    # and check whether the flat was bought or not
    square = find_by_id('square', match: :first).text
    n_rooms = find_by_id('n_rooms', match: :first).text
    floor = find_by_id('floor', match: :first).text
    hs_type = find_by_id('hs_type', match: :first).text
    n_floors = find_by_id('n_floors', match: :first).text
    price = find_by_id('price', match: :first).text

    find_button('Buy', match: :first).click
    
    # expectations
    sqr = page.all('square')
    expect(sqr).not_to have_content(include(square))
  end

  it 'Should delete request' do
    visit('/show_requests')
    n_rooms = find_by_id('n_rooms', match: :first)
    dist = find_by_id('dist', match: :first)
    hs_type = find_by_id('hs_type', match: :first)
    find_button('Remove', match: :first).click
     
    expect(page).not_to have_content(include(n_rooms).and include(dist).and include(hs_type))
  end

  it 'Should delete flat' do
    visit('show_flats')
    square = find_by_id('square', match: :first).text
    n_rooms = find_by_id('n_rooms', match: :first).text
    floor = find_by_id('floor', match: :first).text
    hs_type = find_by_id('hs_type', match: :first).text
    n_floors = find_by_id('n_floors', match: :first).text
    price = find_by_id('price-0', match: :first).text

    find_button('Remove', match: :first).click

    expect(page).not_to have_content(include(n_rooms).and include(floor).and include(hs_type).and include(n_floors).and include(price))
  end
end
