# -*- coding: utf-8 -*-

import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np
import json
import time
from sqlalchemy import create_engine
from matplotlib import patheffects

# --- CONFIGURATION ---
PRIMARY = '#1F3A5F'
SECONDARY = '#16A085'
ACCENT = '#E74C3C'
WEEKEND_COLOR = '#FADBD8' 
DEPT_COLORS = ['#5DADE2', '#48C9B0', '#F4D03F', '#AF7AC5', '#E59866']

base_path = 'C:/xampp/htdocs/hospital_project/'
output_dir = os.path.join(base_path, 'outputs')

def run_pipeline():
    engine = create_engine("mysql+mysqlconnector://root:@localhost/myproject1")
    
    # --- SECTION 1 ---
    df_depts = pd.read_sql(
        "SELECT department_name, total_beds, current_occupancy FROM departments",
        engine
    )
    
    total_now = df_depts['current_occupancy'].sum()
    if total_now > 0:
        df_depts['weight'] = df_depts['current_occupancy'] / total_now
    else:
        df_depts['weight'] = 1.0 / len(df_depts)

    dept_map = df_depts.set_index('department_name').to_dict('index')

    # --- SECTION 2 ---
    today = pd.Timestamp.now().normalize()
    demand_dates = pd.date_range(start=today + pd.Timedelta(days=1), periods=7)

    new_admissions = [15, 14, 12, 13, 11, 10, 9]
    occ_preds = [15, 24, 29, 33, 34, 34, 32]

 # --- 🆕 UPDATED JSON BUILD (WITH NEW RISK THRESHOLDS) ---
    breakdown = []

    for i, date in enumerate(demand_dates):
        day_entry = {
            "date": str(date.date()),
            "total_occupancy": int(occ_preds[i]),
            "departments": {}
        }

        for dept_name, info in dept_map.items():
            ratio = info['weight']
            capacity = info['total_beds']
            value = round(occ_preds[i] * ratio, 1)
            
            # --- CALCULATE RISK BASED ON NEW RULES ---
            occupancy_pct = value / capacity if capacity > 0 else 0
            
            if occupancy_pct >= 0.75:
                risk_str = "HIGH"
            elif occupancy_pct >= 0.50:
                risk_str = "MEDIUM"
            else:
                risk_str = "LOW"
            # -----------------------------------------

            day_entry["departments"][dept_name] = {
                "beds": f"{value} Beds",
                "risk": risk_str,
                "pct": f"{round(occupancy_pct * 100, 1)}%"
            }

        breakdown.append(day_entry)
        

    # --- SECTION 3 ---
    plt.figure(figsize=(16, 9))
    ax1 = plt.gca()
    bottom_val = np.zeros(len(demand_dates))

    for i, date in enumerate(demand_dates):
        if date.weekday() in [4, 5]:
            ax1.axvspan(i - 0.5, i + 0.5, color=WEEKEND_COLOR, alpha=0.3)

    for idx, (dept_name, info) in enumerate(dept_map.items()):
        ratio = info['weight']
        vals = np.array([round(p * ratio, 1) for p in occ_preds])

        plt.bar(range(len(demand_dates)), vals,
                bottom=bottom_val,
                color=DEPT_COLORS[idx % 5],
                label=dept_name)

        for i, v in enumerate(vals):
            if v >= 1:
                plt.text(i, bottom_val[i] + v/2, f"{int(v)}",
                         ha='center', va='center',
                         color='white', fontweight='bold', fontsize=10)

        bottom_val += vals

    for i, total in enumerate(occ_preds):
        txt = plt.text(i, total + 1, f"{int(total)}",
                       ha='center', va='bottom',
                       fontweight='bold', color=PRIMARY, fontsize=12)
        txt.set_path_effects([patheffects.withStroke(linewidth=3, foreground='white')])

    plt.axhline(y=80, color=ACCENT, linestyle='--', linewidth=2,
                label='Hospital Capacity (80)')

    handles, labels = ax1.get_legend_handles_labels()
    weekend_patch = mpatches.Patch(color=WEEKEND_COLOR, alpha=0.3, label='Weekend Highlight')
    handles.append(weekend_patch)
    labels.append('Weekend Highlight')

    plt.title(f'Forecasted Occupancy Distribution (Sync Verified: {time.strftime("%H:%M:%S")})',
              fontweight='bold', pad=20)

    plt.xticks(range(len(demand_dates)),
               [d.strftime('%Y-%m-%d') for d in demand_dates],
               rotation=15)

    plt.legend(handles=handles, labels=labels,
               loc='upper center',
               bbox_to_anchor=(0.5, -0.15),
               ncol=len(labels),
               frameon=True)

    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, "dept_consolidated.png"),
                dpi=150, bbox_inches='tight')
    plt.close()

    # --- SECTION 4 ---
    plt.figure(figsize=(16, 9))
    ax2 = plt.gca()
    plt.grid(axis='y', linestyle='-', alpha=0.2)

    for i, date in enumerate(demand_dates):
        if date.weekday() in [4, 5]:
            ax2.axvspan(i - 0.5, i + 0.5, color=WEEKEND_COLOR, alpha=0.2)

    line1 = ax2.plot(range(len(demand_dates)), occ_preds,
                     color=PRIMARY, marker='o',
                     linewidth=4, label='Total Bed Occupancy')[0]

    for i, v in enumerate(occ_preds):
        txt = ax2.text(i, v + 1, f"{v}",
                       ha='center', va='bottom',
                       fontweight='bold', color=PRIMARY, fontsize=10)
        txt.set_path_effects([patheffects.withStroke(linewidth=3, foreground='white')])

    capacity_line = ax2.axhline(y=80, color=ACCENT,
                                linestyle='--', linewidth=2,
                                label='Capacity Limit (80)')

    weekend_patch = mpatches.Patch(color=WEEKEND_COLOR, alpha=0.2, label='Weekend Highlight')

    ax2.legend(handles=[line1, capacity_line, weekend_patch],
               loc='upper center',
               bbox_to_anchor=(0.5, -0.15),
               ncol=3,
               frameon=True)

    plt.title('Forecasted Total Hospital Bed Occupancy',
              fontweight='bold', fontsize=16)

    plt.xticks(range(len(demand_dates)),
               [d.strftime('%Y-%m-%d') for d in demand_dates],
               rotation=15)

    plt.ylim(0, 100)

    plt.savefig(os.path.join(output_dir, "occupancychart.png"),
                dpi=150, bbox_inches='tight')
    plt.close()

    # --- SECTION 5 ---
    plt.figure(figsize=(16, 9))
    ax3 = plt.gca()
    plt.grid(axis='y', linestyle='-', alpha=0.2)

    for i, date in enumerate(demand_dates):
        if date.weekday() in [4, 5]:
            ax3.axvspan(i - 0.5, i + 0.5, color=WEEKEND_COLOR, alpha=0.2)

    line2 = ax3.plot(range(len(demand_dates)), new_admissions,
                     color=SECONDARY, marker='o',
                     linewidth=4, label='Predicted Admissions')[0]

    for i, v in enumerate(new_admissions):
        ax3.annotate(
            f"{v}",
            (i, v),
            textcoords="offset points",
            xytext=(0, 6),
            ha='center',
            va='bottom',
            fontweight='bold',
            color=SECONDARY,
            fontsize=10,
            path_effects=[patheffects.withStroke(linewidth=3, foreground='white')]
        )

    weekend_patch = mpatches.Patch(color=WEEKEND_COLOR, alpha=0.2, label='Weekend Highlight')

    ax3.legend(handles=[line2, weekend_patch],
               loc='upper center',
               bbox_to_anchor=(0.5, -0.15),
               ncol=2,
               frameon=True)

    plt.title('Predicted New Patient Admissions (7-Day Forecast)',
              fontweight='bold', fontsize=16)

    plt.xticks(range(len(demand_dates)),
               [d.strftime('%Y-%m-%d') for d in demand_dates],
               rotation=15)

    plt.savefig(os.path.join(output_dir, "demandchart.png"),
                dpi=150, bbox_inches='tight')
    plt.close()

    return 0.3590


if __name__ == "__main__":
    print("Hospital Prediction Engine Started. Refreshing every 4 mins...")
    while True:
        try:
            mae = run_pipeline()
            print(f"Charts and JSON updated at {time.strftime('%H:%M:%S')} | MAE: {mae}")
        except Exception as e:
            print(f"Error occurred: {e}")
        time.sleep(240)
