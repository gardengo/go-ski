package com.go.ski.payment.support.dto.response;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.go.ski.payment.support.dto.util.Amount;
import com.go.ski.payment.support.dto.util.CardInfo;

import lombok.Getter;

@Getter
public class ApprovePaymentResponseDTO {
	@JsonProperty("aid")
	private String aid;
	@JsonProperty("tid")
	private String tid;
	@JsonProperty("cid")
	private String cid;
	@JsonProperty("sid")
	private String sid;
	@JsonProperty("partner_order_id")
	private String partnerOrderId;
	@JsonProperty("partner_user_id")
	private String partnerUserId;
	@JsonProperty("payment_method_type")
	private String paymentMethodType;
	@JsonProperty("amount")
	private Amount amount;
	@JsonProperty("card_info")
	private CardInfo cardInfo;
	@JsonProperty("item_name")
	private String itemName;
	@JsonProperty("item_code")
	private String itemCode;
	@JsonProperty("quantity")
	private int quantity;
	@JsonProperty("created_at")
	private LocalDate createdAt;
	@JsonProperty("approved_at")
	private LocalDate approvedAt;
}
