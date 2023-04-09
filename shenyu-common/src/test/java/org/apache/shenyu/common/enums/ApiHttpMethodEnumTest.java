package org.apache.shenyu.common.enums;

import org.apache.shenyu.common.exception.ShenyuException;
import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test Cases for ApiHttpMethodEnum.
 */
public final class ApiHttpMethodEnumTest {

    @Test
    public void testGetName(){

        Arrays.stream(ApiHttpMethodEnum.values())
                .forEach(apiHttpMethodEnum -> assertEquals(apiHttpMethodEnum.toString(), ApiHttpMethodEnum.valueOf(apiHttpMethodEnum.name()).getName()));
    }

    @Test
    public void testGetValue(){

        assertEquals(0, ApiHttpMethodEnum.GET.getValue());
        assertEquals(1, ApiHttpMethodEnum.HEAD.getValue());
        assertEquals(2, ApiHttpMethodEnum.POST.getValue());
        assertEquals(3, ApiHttpMethodEnum.PUT.getValue());
        assertEquals(4, ApiHttpMethodEnum.PATCH.getValue());
        assertEquals(5, ApiHttpMethodEnum.DELETE.getValue());
        assertEquals(6, ApiHttpMethodEnum.OPTIONS.getValue());
        assertEquals(7, ApiHttpMethodEnum.TRACE.getValue());
        assertEquals(8, ApiHttpMethodEnum.NOT_HTTP.getValue());
    }

    @Test
    public void testGetValueByName(){

        assertEquals(0, ApiHttpMethodEnum.getValueByName("GET"));
        assertEquals(1, ApiHttpMethodEnum.getValueByName("HEAD"));
        assertEquals(2, ApiHttpMethodEnum.getValueByName("POST"));
        assertEquals(3, ApiHttpMethodEnum.getValueByName("PUT"));
        assertEquals(4, ApiHttpMethodEnum.getValueByName("PATCH"));
        assertEquals(5, ApiHttpMethodEnum.getValueByName("DELETE"));
        assertEquals(6, ApiHttpMethodEnum.getValueByName("OPTIONS"));
        assertEquals(7, ApiHttpMethodEnum.getValueByName("TRACE"));
        assertEquals(8, ApiHttpMethodEnum.getValueByName("NOT_HTTP"));
    }

    @Test
    public void testGetValueByNameException(){

        assertThrows(ShenyuException.class, () -> ApiHttpMethodEnum.getValueByName("abc"));
    }

    @Test
    public void testOf(){

        Arrays.stream(ApiHttpMethodEnum.values())
                .forEach(apiHttpMethodEnum -> assertEquals(apiHttpMethodEnum, ApiHttpMethodEnum.of(apiHttpMethodEnum.name())));
    }

    @Test
    public void testOfException(){

        assertThrows(ShenyuException.class, () -> ApiHttpMethodEnum.of("abc"));
    }



}