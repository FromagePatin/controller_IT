#include "IT_controller.h"

void nIT_CPU_Handler(void)
{
    CTRL_IT->handler();
}

void UART_Handler(void)
{
    /* Do somethink */
    /* clear UART IT flag */
}

void CTRL_IT_init_UART(void)
{
    /* Disable CTRL IT */
    CTRL_IT->CTRL_IT_EN = 0x0000;

    /* Mask the IC channel */
    CTRL_IT->CTRL_IT_MSK = 1UL << nIT_UART;

    /* Set handler addr */
    CTRL_IT->CTRL_IT_ADDR[nIT_UART] = &UART_Handler;

    /* Enable CTRL IT */
    CTRL_IT->CTRL_IT_EN = 0x0001;
}



/* Other case where different source are groupes with the branch address */

void Ext_Handler(void)
{
    if (CTRL_IT->CTRL_IT_PEND & (1UL << nIT_ext0))
        /* ... */;
    if (CTRL_IT->CTRL_IT_PEND & (1UL << nIT_ext1))
        /* ... */;
    if (CTRL_IT->CTRL_IT_PEND & (1UL << nIT_ext2))
        /* ... */;
    if (CTRL_IT->CTRL_IT_PEND & (1UL << nIT_ext3))
        /* ... */;
}

void CTRL_IT_init_Ext(void)
{
    /* Disable CTRL IT */
    CTRL_IT->CTRL_IT_EN = 0x0000;

    for (ID_IT_t i = nIT_ext0; i <= nIT_ext3; i++)
    {
        /* Set 4 external IT priority to 3 */
        CTRL_IT->prio[i].ch = 0x3;
        /* Group Ext IT setting same handler addr */
        CTRL_IT->CTRL_IT_ADDR[i] = &Ext_Handler;
    }

    /* Enable CTRL IT */
    CTRL_IT->CTRL_IT_EN = 0x0001;
}