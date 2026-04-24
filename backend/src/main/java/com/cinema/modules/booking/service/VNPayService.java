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

    @Value("${vnpay.tmn-code}")
    private String tmnCode;

    @Value("${vnpay.hash-secret}")
    private String hashSecret;

    @Value("${vnpay.url}")
    private String vnpayUrl;

    @Value("${vnpay.return-url}")
    private String returnUrl;

    @Value("${vnpay.ipn-url}")
    private String ipnUrl;

    // Tạo URL thanh toán gửi về frontend
    public String createPaymentUrl(java.util.UUID invoiceId, BigDecimal amount, String orderInfo) throws Exception {
        Map<String, String> params = new TreeMap<>(); // TreeMap tự sắp xếp theo alphabet - bắt buộc với VNPay

        params.put("vnp_Version", "2.1.0");
        params.put("vnp_Command", "pay");
        params.put("vnp_TmnCode", tmnCode);
        params.put("vnp_Amount", String.valueOf(amount.multiply(new BigDecimal("100")).longValue())); // VNPay tính theo đơn vị VNĐ * 100
        params.put("vnp_CurrCode", "VND");
        params.put("vnp_TxnRef", invoiceId.toString().replace("-", ""));
        params.put("vnp_OrderInfo", orderInfo);
        params.put("vnp_OrderType", "other");
        params.put("vnp_Locale", "vn");
        params.put("vnp_ReturnUrl", returnUrl);
        params.put("vnp_IpAddr", "127.0.0.1");
        params.put("vnp_CreateDate", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        params.put("vnp_ExpireDate", LocalDateTime.now().plusMinutes(15).format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        

        // Tạo chuỗi hash
        // Hash dùng raw value (không encode)
        String rawData = buildRawString(params);
        String secureHash = hmacSHA512(hashSecret, rawData);

        // URL dùng encoded value
        String queryString = buildQueryString(params);
        return vnpayUrl + "?" + queryString 
            + "&vnp_IpnUrl=" + URLEncoder.encode(ipnUrl, StandardCharsets.UTF_8)
            + "&vnp_SecureHash=" + secureHash;
    }

    // Xác minh chữ ký callback từ VNPay (tránh giả mạo)
    public boolean verifyCallback(Map<String, String> params) throws Exception {
        String receivedHash = params.get("vnp_SecureHash");
        if (receivedHash == null) return false;

        // Tạo map mới bỏ các field hash ra
        Map<String, String> verifyParams = new TreeMap<>(params);
        verifyParams.remove("vnp_SecureHash");
        verifyParams.remove("vnp_SecureHashType");

        String rawData = buildRawString(verifyParams);
        String calculatedHash = hmacSHA512(hashSecret, rawData);

        return calculatedHash.equalsIgnoreCase(receivedHash);
    }

    // --- Helper methods ---

    private String buildQueryString(Map<String, String> params) throws Exception {
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (sb.length() > 0) sb.append("&");
            sb.append(entry.getKey());
            sb.append("=");
            sb.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
        }
        return sb.toString();
    }

    private String buildRawString(Map<String, String> params) throws Exception {
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (sb.length() > 0) sb.append("&");
            sb.append(entry.getKey());
            sb.append("=");
            sb.append(URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII.toString())); // encode US_ASCII
        }
        return sb.toString();
    }

    private String hmacSHA512(String key, String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA512");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
        byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));

        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}