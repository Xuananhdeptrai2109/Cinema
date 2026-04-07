package com.cinema.modules.cinema.service;

import com.cinema.modules.cinema.entity.Cinema;
import com.cinema.modules.cinema.entity.ProvinceCity;
import com.cinema.modules.cinema.repository.CinemaRepository;
import com.cinema.modules.cinema.repository.ProvinceRepository;
import com.cinema.modules.cinema.response.CinemaResponse;
import com.cinema.modules.cinema.response.ProvinceResponse;
import com.cinema.modules.room.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

@Service
@Transactional
public class CinemaServiceImpl implements CinemaService {
    @Autowired
    private ProvinceRepository provinceRepository;

    @Autowired
    private CinemaRepository cinemaRepository;

    @Autowired
    private RoomService roomService;

    @Override
    public List<CinemaResponse> getCinemasResponseByProvinceName(String cityName) {
        List<Cinema> cinemas = cinemaRepository.findByProvince_ProvinceName(cityName);

        return cinemas.stream().map(cinema -> {
            CinemaResponse cRes = new CinemaResponse();
            cRes.setCinemasId(cinema.getCinemasId());
            cRes.setCinemaName(cinema.getCinemaName());
            cRes.setAddress(cinema.getAddress());
            cRes.setImageUrl(cinema.getImageUrl());
            // Map các trường khác cần thiết cho booking.js
            return cRes;
        }).collect(Collectors.toList());
    }

    @Override
    public List<ProvinceResponse> getAllLocationsWithCinemas() {
        List<ProvinceCity> provinces = provinceRepository.findAllWithCinemas();

        return provinces.stream().map(province -> {
            ProvinceResponse pRes = new ProvinceResponse();
            pRes.setProvinceId(province.getProvinceId());
            pRes.setProvinceName(province.getProvinceName());

            List<CinemaResponse> cinemaResList = province.getCinemas().stream().map(cinema -> {
                CinemaResponse cRes = new CinemaResponse();

                cRes.setCinemasId(cinema.getCinemasId());
                cRes.setCinemaName(cinema.getCinemaName());
                cRes.setAddress(cinema.getAddress());

                cRes.setImageUrl(cinema.getImageUrl());
                cRes.setMapUrl(cinema.getMapUrl());
                cRes.setHotline(cinema.getHotline());

                cRes.setScreeningTypes(roomService.getScreeningTypesByCinema(cinema.getCinemasId()));

                return cRes;
            }).collect(Collectors.toList());

            pRes.setCinemas(cinemaResList);
            return pRes;
        }).collect(Collectors.toList());
    }
}