#include <stdint.h>

#define CTRL_IT_BASE_ADDR 0x000000;

typedef enum 
{
    nIT_ext0 = 0,
    nIT_ext1,
    nIT_ext2,
    nIT_ext3,
    nIT_RTC,
    nIT_TC_PWM,
    nIT_pos_vit,
    nIT_FFTA,
    nIT_NNA,
    nIT_SPI,
    nIT_PCI,
    nIT_UART,
    nIT_I2C,
    nIT_CAN,
    nIT_DMA,
    NB_IT
}ID_IT_t;

typedef struct 
{
    uint8_t ch : 3;
    uint8_t RESERVED : 5;
}CTRL_IT_PRIO_t;
/* expected size 1 byte */
//static_assert(sizeof(CTRL_IT_PRIO_t)==1, "Error struct size");

typedef struct 
{
    uint16_t CTRL_IT_EN;
    uint16_t CTRL_IT_MSK;
    uint16_t CTRL_IT_PEND;
    void (*handler)(void);
    /* array of function pointer */
    void (*CTRL_IT_ADDR[NB_IT])(void);
    CTRL_IT_PRIO_t prio[NB_IT];
}CTRL_IT_t;

CTRL_IT_t * CTRL_IT = CTRL_IT_BASE_ADDR;

void nIT_CPU_Handler (void);