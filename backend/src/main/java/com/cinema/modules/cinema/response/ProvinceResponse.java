package com.cinema.modules.cinema.response;

import lombok.Data;
import java.util.List;

@Data
public class ProvinceResponse {
    private Long provinceId;
    private String provinceName;
    private List<CinemaResponse> cinemas;
}
