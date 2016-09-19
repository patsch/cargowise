## Overview

EnterpriseEDI is a commercial shipping and logistics software package by
Cargowise and used by logistics companies. Depending on the setup it often has
a SOAP API for clients shipping stuff can check on it's progress. Think
tracking your Fedex package but on a larger scale.

This library provides a nice object based wrapper around the API so you can
pretend the nasty SOAP behind it doesn't exist.

I am in no way personally affiliated with Cargowise or companies that use
EnterpriseEDI. This library was put together for a project that needed access
to specific details of upcoming shipments.

## Installation

    gem install cargowise

## Usage

The cargowise API exposes two resources - Order and Shipment. Depending on your
logistics company and what data they record there may be useful information on
either or both.

### Registering Endpoints

Each company using the cargowise product hosts the server themselves, so you will
need to register the URI and authentication details for the company you want to use.

    client = Cargowise::Client.new(:order_uri => "<base_url>/WebService/OrderService.asmx",
                                   :shipment_uri => "<base_url>/WebService/ShipmentService.asmx",
                                   :company_code => "company_code",
                                   :username => "user@example.com",
                                   :password => "secret")

In a rails app the registration should be done in a file like
config/initializers/cargowise.rb.

If you deal with multiple companies running cargowise you should create a client
instance per company.

See the Finding API Endpoints section below for tips on finding the correct URI
to register.

### Querying

Cargowise::Order is a purchase order. It's for tracking the status of an order
as it makes it's way from a supplier to you. For these to exist you probably need to
have an arrangement with the logistics company to send them copies when you place
the order.

To find all orders with a certain order number:

    client.orders.by_order_number("123456")

To find all incomplete orders:

    client.orders.incomplete

Cargowise::Shipment represents something being sent to you - like a carton,
palet or truck load. It might be transported via air, sea, road or a combination.

To find shipments by the shipment number (a reference number selected by your logistics
company):

    client.shipments.by_shipment_number("123456")

To find undelivered shipments:

    client.shipments.undelivered

To find shipments with activity in the past 14 days (or so):

    client.shipments.with_recent_activity

All Order and Shipment objects are read only, there are no write capabale
methods exposed via the API. If you see errors, contact your logistics company.

## Finding API Endpoints

Logistics companies that run EnterpriseEDI often don't realise they have an API
so tracking down information on how to set it up can be tricky.

If they have a website for tracking you can start with that URL and then guess
the rest.

For example, OHLs web tracking site is at:

* https://webtracking.ohl.com/

## Links

* Cargowise: http://www.cargowise.com/
