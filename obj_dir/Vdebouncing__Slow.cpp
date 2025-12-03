// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdebouncing.h for the primary calling header

#include "Vdebouncing.h"
#include "Vdebouncing__Syms.h"

//==========

VL_CTOR_IMP(Vdebouncing) {
    Vdebouncing__Syms* __restrict vlSymsp = __VlSymsp = new Vdebouncing__Syms(this, name());
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vdebouncing::__Vconfigure(Vdebouncing__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

Vdebouncing::~Vdebouncing() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void Vdebouncing::_settle__TOP__2(Vdebouncing__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::_settle__TOP__2\n"); );
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->buttonMux = ((~ (IData)(vlTOPp->debouncing__DOT__oldestRow)) 
                         & (IData)(vlTOPp->debouncing__DOT__oldRow));
}

void Vdebouncing::_eval_initial(Vdebouncing__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::_eval_initial\n"); );
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
    vlTOPp->__Vclklast__TOP__rst = vlTOPp->rst;
}

void Vdebouncing::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::final\n"); );
    // Variables
    Vdebouncing__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vdebouncing::_eval_settle(Vdebouncing__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::_eval_settle\n"); );
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__2(vlSymsp);
}

void Vdebouncing::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::_ctor_var_reset\n"); );
    // Body
    clk = VL_RAND_RESET_I(1);
    rst = VL_RAND_RESET_I(1);
    en = VL_RAND_RESET_I(1);
    row = VL_RAND_RESET_I(4);
    buttonMux = VL_RAND_RESET_I(4);
    debouncing__DOT__newRow = VL_RAND_RESET_I(4);
    debouncing__DOT__oldRow = VL_RAND_RESET_I(4);
    debouncing__DOT__oldestRow = VL_RAND_RESET_I(4);
    { int __Vi0=0; for (; __Vi0<2; ++__Vi0) {
            __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }}
}
