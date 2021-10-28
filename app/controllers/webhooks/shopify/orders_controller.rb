module Webhooks
  module Shopify
    class OrdersController < Webhooks::ApplicationController
      # orders/paid
      def create
        hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
        data = request.body.read
        return head 403 if hmac_header.blank? || !webhook_verified?(data, hmac_header)

        payload = JSON.parse data
        begin
         PointTransaction.new_order_paid(payload)
        rescue => e
          respond_with_error '',400
        end
        render head, status: 200
      end
    end
  end
end
