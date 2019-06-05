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
    fill_in('n_rooms', with: '10')
    fill_in('district', with: 'District #99')
    select('Panel', from: 'hs_type')
    click_on('Add')
    expect(page).to have_content('10')
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
    fill_in('price', with: 'PT99999')
    click_on('Add')
    expect(page).to have_content('ST99999')
    expect(page).to have_content('NRT99999')
    expect(page).to have_content('T_dist #T')
    expect(page).to have_content('T_street #T')
    expect(page).to have_content('T_n_house #T')
    expect(page).to have_content('FT99999')
    expect(page).to have_content('Panel')
    expect(page).to have_content('NFT99999')
    expect(page).to have_content('PT99999')
  end
end
