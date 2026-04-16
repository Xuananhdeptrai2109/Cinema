package com.cinema.modules.auth.dto;

public class ResetPasswordRequest {
    private String email;
    private String otp;
    private String newPassword;

    // Getter & Setter cho Email
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    // Getter & Setter cho OTP
    public String getOtp() {
        return otp;
    }
    public void setOtp(String otp) {
        this.otp = otp;
    }

    // Getter & Setter cho Mật khẩu mới
    public String getNewPassword() {
        return newPassword;
    }
    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
}