// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdebouncing.h for the primary calling header

#include "Vdebouncing.h"
#include "Vdebouncing__Syms.h"

//==========

void Vdebouncing::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vdebouncing::eval\n"); );
    Vdebouncing__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("source/debouncing.sv", 1, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vdebouncing::_eval_initial_loop(Vdebouncing__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("source/debouncing.sv", 1, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vdebouncing::_sequent__TOP__1(Vdebouncing__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::_sequent__TOP__1\n"); );
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (vlTOPp->rst) {
        vlTOPp->debouncing__DOT__oldestRow = 0U;
        vlTOPp->debouncing__DOT__oldRow = 0U;
    } else {
        vlTOPp->debouncing__DOT__oldestRow = ((IData)(vlTOPp->en)
                                               ? (IData)(vlTOPp->debouncing__DOT__oldRow)
                                               : 0U);
        vlTOPp->debouncing__DOT__oldRow = ((IData)(vlTOPp->en)
                                            ? (IData)(vlTOPp->debouncing__DOT__newRow)
                                            : 0U);
    }
    vlTOPp->buttonMux = ((~ (IData)(vlTOPp->debouncing__DOT__oldestRow)) 
                         & (IData)(vlTOPp->debouncing__DOT__oldRow));
    vlTOPp->debouncing__DOT__newRow = ((IData)(vlTOPp->rst)
                                        ? 0U : ((IData)(vlTOPp->en)
                                                 ? (IData)(vlTOPp->row)
                                                 : 0U));
}

void Vdebouncing::_eval(Vdebouncing__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::_eval\n"); );
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if ((((IData)(vlTOPp->clk) & (~ (IData)(vlTOPp->__Vclklast__TOP__clk))) 
         | ((IData)(vlTOPp->rst) & (~ (IData)(vlTOPp->__Vclklast__TOP__rst))))) {
        vlTOPp->_sequent__TOP__1(vlSymsp);
        vlTOPp->__Vm_traceActivity[1U] = 1U;
    }
    // Final
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
    vlTOPp->__Vclklast__TOP__rst = vlTOPp->rst;
}

VL_INLINE_OPT QData Vdebouncing::_change_request(Vdebouncing__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::_change_request\n"); );
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vdebouncing::_change_request_1(Vdebouncing__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::_change_request_1\n"); );
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vdebouncing::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdebouncing::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
    if (VL_UNLIKELY((en & 0xfeU))) {
        Verilated::overWidthError("en");}
    if (VL_UNLIKELY((row & 0xf0U))) {
        Verilated::overWidthError("row");}
}
#endif  // VL_DEBUG
