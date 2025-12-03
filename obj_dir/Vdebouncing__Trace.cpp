// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdebouncing__Syms.h"


void Vdebouncing::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vdebouncing__Syms* __restrict vlSymsp = static_cast<Vdebouncing__Syms*>(userp);
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vdebouncing::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vdebouncing__Syms* __restrict vlSymsp = static_cast<Vdebouncing__Syms*>(userp);
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgCData(oldp+0,(vlTOPp->debouncing__DOT__newRow),4);
            tracep->chgCData(oldp+1,(vlTOPp->debouncing__DOT__oldRow),4);
            tracep->chgCData(oldp+2,(vlTOPp->debouncing__DOT__oldestRow),4);
        }
        tracep->chgBit(oldp+3,(vlTOPp->clk));
        tracep->chgBit(oldp+4,(vlTOPp->rst));
        tracep->chgBit(oldp+5,(vlTOPp->en));
        tracep->chgCData(oldp+6,(vlTOPp->row),4);
        tracep->chgCData(oldp+7,(vlTOPp->buttonMux),4);
        tracep->chgCData(oldp+8,(((IData)(vlTOPp->en)
                                   ? (IData)(vlTOPp->row)
                                   : 0U)),4);
        tracep->chgCData(oldp+9,(((IData)(vlTOPp->en)
                                   ? (IData)(vlTOPp->debouncing__DOT__newRow)
                                   : 0U)),4);
        tracep->chgCData(oldp+10,(((IData)(vlTOPp->en)
                                    ? (IData)(vlTOPp->debouncing__DOT__oldRow)
                                    : 0U)),4);
    }
}

void Vdebouncing::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vdebouncing__Syms* __restrict vlSymsp = static_cast<Vdebouncing__Syms*>(userp);
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
    }
}
