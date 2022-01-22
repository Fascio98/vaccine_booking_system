import {Controller} from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
    static targets = ["country","city","district"]

    connect() {
        console.log('Hello, Stimulus')
    }

    fetchCities() {
        Rails.ajax(
            {
                type: "GET",
                url: "/admin/business_units/fetch_cities",
                data: "country_id=" + this.countryTarget.value,
                success: (data) => {
                    this.cityTarget.innerHTML = data.body.innerHTML
                }
            }
        );
    }

    fetchDistricts() {
        Rails.ajax(
            {
                type: "GET",
                url: "/admin/business_units/fetch_districts",
                data: "city_id=" + this.cityTarget.value,
                success: (data) => {
                    this.districtTarget.innerHTML = data.body.innerHTML
                }
            }
        );
    }
}