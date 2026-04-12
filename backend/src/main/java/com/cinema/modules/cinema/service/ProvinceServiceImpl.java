package com.cinema.modules.cinema.service;

import com.cinema.modules.cinema.repository.ProvinceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProvinceServiceImpl implements ProvinceService {
    @Autowired
    private ProvinceRepository provinceRepository;

    @Override
    public List<String> getAllProvinceNames() {
        // Giả sử Entity Province của bạn có trường 'provinceName'
        return provinceRepository.findAll().stream()
                .map(province -> province.getProvinceName())
                .collect(Collectors.toList());
    }
}