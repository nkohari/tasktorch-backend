_                  = require 'lodash'
BillingSourceBrand = require 'data/enums/BillingSourceBrand'

class BillingSource

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
      when 'Visa'             then BillingSourceBrand.Visa
      when 'MasterCard'       then BillingSourceBrand.MasterCard
      when 'American Express' then BillingSourceBrand.AmericanExpress
      when 'Discover'         then BillingSourceBrand.Discover
      when 'JCB'              then BillingSourceBrand.JCB
      when 'DinersClub'       then BillingSourceBrand.DinersClub
      else
        BillingSourceBrand.Unknown

module.exports = BillingSource
