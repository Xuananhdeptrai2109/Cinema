package com.cinema.modules.booking.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class VNPayService {

    @Value("${vnpay.tmn-code}") private String tmnCode;
    @Value("${vnpay.hash-secret}") private String hashSecret;
    @Value("${vnpay.url}") private String vnpayUrl;
    @Value("${vnpay.return-url}") private String returnUrl;

    public String createPaymentUrl(java.util.UUID invoiceId, BigDecimal amount, String orderInfo) throws Exception {
        Map<String, String> params = new TreeMap<>();
        params.put("vnp_Version", "2.1.0");
        params.put("vnp_Command", "pay");
        params.put("vnp_TmnCode", tmnCode.trim());

        long vnpAmount = amount.multiply(new BigDecimal("100")).longValue();
        if (vnpAmount < 1000000) vnpAmount = 1000000;
        params.put("vnp_Amount", String.valueOf(vnpAmount));
        params.put("vnp_CurrCode", "VND");
        params.put("vnp_TxnRef", invoiceId.toString().replace("-", ""));
        params.put("vnp_OrderInfo", "ThanhToanHoaDonCinema");
        params.put("vnp_OrderType", "other");
        params.put("vnp_Locale", "vn");
        params.put("vnp_ReturnUrl", returnUrl.trim());
        params.put("vnp_IpAddr", "14.226.173.123");
        params.put("vnp_CreateDate", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        String queryString = buildDataString(params, true);
        String hashData = buildDataString(params, false);

        String secretKey = hashSecret;
        String secureHash = hmacSHA512(secretKey, hashData).toUpperCase();

        String finalUrl = vnpayUrl + "?" + queryString + "&vnp_SecureHash=" + secureHash;

        System.out.println("--- DEBUG VNPAY HARDCODE ---");
        System.out.println("Chuỗi băm (hashData): " + hashData);
        System.out.println("URL cuối: " + finalUrl);

        return finalUrl;
    }

    public boolean verifyCallback(Map<String, String> params) throws Exception {
        String receivedHash = params.get("vnp_SecureHash");
        if (receivedHash == null) return false;

        Map<String, String> verifyParams = new TreeMap<>(params);
        verifyParams.remove("vnp_SecureHash");
        verifyParams.remove("vnp_SecureHashType");

        // Sử dụng chung hàm buildDataString với chế độ băm (encode value, raw key)[cite: 6, 11]
        String hashData = buildDataString(verifyParams, false);
        String calculatedHash = hmacSHA512(hashSecret.trim(), hashData);

        return calculatedHash.equalsIgnoreCase(receivedHash);
    }

    // --- Helper Method dùng chung cho cả tạo và xác thực ---
    private String buildDataString(Map<String, String> params, boolean encodeKey) throws Exception {
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().isEmpty()) {
                if (sb.length() > 0) sb.append("&");

                // Key: Encode nếu là chuỗi Query, giữ nguyên nếu là chuỗi Hash[cite: 6]
                if (encodeKey) {
                    sb.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8).replace("+", "%20"));
                } else {
                    sb.append(entry.getKey());
                }

                sb.append("=");
                // Value: Luôn encode và thay + thành %20[cite: 6, 11]
                sb.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8).replace("+", "%20"));
            }
        }
        return sb.toString();
    }

    private String hmacSHA512(String key, String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA512");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
        byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) sb.append(String.format("%02X", b));
        return sb.toString();
    }
}