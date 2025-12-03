// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdebouncing__Syms.h"


//======================

void Vdebouncing::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void Vdebouncing::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vdebouncing__Syms* __restrict vlSymsp = static_cast<Vdebouncing__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    Vdebouncing::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void Vdebouncing::traceInitTop(void* userp, VerilatedVcd* tracep) {
    Vdebouncing__Syms* __restrict vlSymsp = static_cast<Vdebouncing__Syms*>(userp);
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void Vdebouncing::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    Vdebouncing__Syms* __restrict vlSymsp = static_cast<Vdebouncing__Syms*>(userp);
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBit(c+4,"clk", false,-1);
        tracep->declBit(c+5,"rst", false,-1);
        tracep->declBit(c+6,"en", false,-1);
        tracep->declBus(c+7,"row", false,-1, 3,0);
        tracep->declBus(c+8,"buttonMux", false,-1, 3,0);
        tracep->declBit(c+4,"debouncing clk", false,-1);
        tracep->declBit(c+5,"debouncing rst", false,-1);
        tracep->declBit(c+6,"debouncing en", false,-1);
        tracep->declBus(c+7,"debouncing row", false,-1, 3,0);
        tracep->declBus(c+8,"debouncing buttonMux", false,-1, 3,0);
        tracep->declBus(c+1,"debouncing newRow", false,-1, 3,0);
        tracep->declBus(c+9,"debouncing newRow_n", false,-1, 3,0);
        tracep->declBus(c+2,"debouncing oldRow", false,-1, 3,0);
        tracep->declBus(c+10,"debouncing oldRow_n", false,-1, 3,0);
        tracep->declBus(c+3,"debouncing oldestRow", false,-1, 3,0);
        tracep->declBus(c+11,"debouncing oldestRow_n", false,-1, 3,0);
    }
}

void Vdebouncing::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void Vdebouncing::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    Vdebouncing__Syms* __restrict vlSymsp = static_cast<Vdebouncing__Syms*>(userp);
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void Vdebouncing::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    Vdebouncing__Syms* __restrict vlSymsp = static_cast<Vdebouncing__Syms*>(userp);
    Vdebouncing* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullCData(oldp+1,(vlTOPp->debouncing__DOT__newRow),4);
        tracep->fullCData(oldp+2,(vlTOPp->debouncing__DOT__oldRow),4);
        tracep->fullCData(oldp+3,(vlTOPp->debouncing__DOT__oldestRow),4);
        tracep->fullBit(oldp+4,(vlTOPp->clk));
        tracep->fullBit(oldp+5,(vlTOPp->rst));
        tracep->fullBit(oldp+6,(vlTOPp->en));
        tracep->fullCData(oldp+7,(vlTOPp->row),4);
        tracep->fullCData(oldp+8,(vlTOPp->buttonMux),4);
        tracep->fullCData(oldp+9,(((IData)(vlTOPp->en)
                                    ? (IData)(vlTOPp->row)
                                    : 0U)),4);
        tracep->fullCData(oldp+10,(((IData)(vlTOPp->en)
                                     ? (IData)(vlTOPp->debouncing__DOT__newRow)
                                     : 0U)),4);
        tracep->fullCData(oldp+11,(((IData)(vlTOPp->en)
                                     ? (IData)(vlTOPp->debouncing__DOT__oldRow)
                                     : 0U)),4);
    }
}
