package com.jifenke.lepluslive.printer.domain.entities;

import javax.persistence.*;

/**
 * Created by lss on 16-12-30.
 */
@Entity
@Table(name = "MEASUREMENT_URL")
public class MeasurementUrl {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String name;

    private String url;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
