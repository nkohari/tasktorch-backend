_                  = require 'lodash'
AccountSourceBrand = require 'data/enums/AccountSourceBrand'

class AccountSource

  constructor: (data) ->
    @id    = data.id
    @brand = @convertBrand(data.brand)
    @last4 = data.last4
    @month = data.exp_month
    @year  = data.exp_year
    @address = {
      line1:   data.address_line1
      line2:   data.address_line2
      city:    data.address_city
      state:   data.address_state
      zip:     data.address_zip
      country: data.country
    }

  convertBrand: (str) ->
    switch str
      when 'Visa'             then AccountSourceBrand.Visa
      when 'MasterCard'       then AccountSourceBrand.MasterCard
      when 'American Express' then AccountSourceBrand.AmericanExpress
      when 'Discover'         then AccountSourceBrand.Discover
      when 'JCB'              then AccountSourceBrand.JCB
      when 'DinersClub'       then AccountSourceBrand.DinersClub
      else
        AccountSourceBrand.Unknown

module.exports = AccountSource
