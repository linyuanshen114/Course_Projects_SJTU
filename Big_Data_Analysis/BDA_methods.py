import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import os
import matplotlib.ticker as mtick


def custom_describe(data):
    # Basic statistics
    desc_stats = data.describe()

    # Missing values count
    missing_values = data.isnull().sum()

    # Unique values count
    unique_values = data.nunique()

    # Identify numeric columns
    numeric_cols = data.select_dtypes(include=['number']).columns

    # Calculate IQR and identify outliers for each numeric column
    outliers = {}
    for col in numeric_cols:
        q1 = desc_stats.loc['25%', col]
        q3 = desc_stats.loc['75%', col]
        iqr = q3 - q1
        lower_bound = q1 - 1.5 * iqr
        upper_bound = q3 + 1.5 * iqr
        outliers[col] = data[((data[col] < lower_bound) | (data[col] > upper_bound))].shape[0]

    # Get data types for each column
    data_types = data.dtypes

    # Combine all information
    custom_description = pd.DataFrame({
        'data_type': data_types,
        'mean': desc_stats.loc['mean'],
        'std': desc_stats.loc['std'],
        'missing_values': missing_values,
        'unique_values': unique_values,
        'outliers': outliers
    })

    custom_description.reset_index(inplace=True)
    custom_description.rename(columns={"index": "column_name"}, inplace=True)
    return custom_description

def convert_string(s):
    # 使用下划线分割字符串
    parts = s.split('_')
    # 将每个部分首字母大写
    capitalized_parts = [part.capitalize() for part in parts]
    # 用空格连接这些部分
    return ' '.join(capitalized_parts)


def histogram_grade_group(name, group, colname="damage_grade"):
    myfolder = "."
    filename = name + ".png"
    file_path = os.path.join(myfolder, filename)

    # Check data types
    print(group[colname].dtypes)

    # Convert to a consistent data type if necessary, e.g., to numeric
    # group[colname] = pd.to_numeric(group[colname], errors='coerce')

    # Or convert to string
    group[colname] = group[colname].astype(str)

    y = group[colname]
    plt.figure()
    sns.set()

    # Now create the countplot
    sns.countplot(x=colname, data=group, label="Damage Grade", color="skyblue", edgecolor="salmon", lw=2,
                  order=sorted(group[colname].dropna().unique()))

    plt.xlabel(convert_string(colname))
    plt.ylabel("Count")
    # plt.yticks(np.arange(0, 1, 0.1))
    plt.title("The Damage Grade of " + name + " with {} obs".format(group.shape[0]))
    plt.legend()
    # plt.savefig(file_path)
    plt.show()


def group_plot_distribution_of_a_column(structure_data, group_colname="district_name", plot_colname="damage_grade",
                                        color="skyblue", edgecolor="salmon"):
    grouped = structure_data.groupby(group_colname)

    # 获取不同的 'district_name' 值
    group_names = list(grouped.groups.keys())

    # 计算要创建的子图的行数和列数
    num_rows = (len(group_names) + 3) // 4  # 每行有四个子图

    # 计算整体图形的大小
    fig_width = 12
    fig_height = fig_width * (1 / 6) * num_rows * 1.4

    # 创建子图
    fig, axes = plt.subplots(num_rows, 4, figsize=(fig_width, fig_height), sharey=True)
    axes = axes.flatten()  # 将二维数组展平

    xlabel = convert_string(plot_colname)
    # 对每个分组绘制 'damage_grade' 子图
    for i, (name, group) in enumerate(grouped):
        ax = axes[i]
        group[plot_colname].value_counts().sort_index().plot(kind='bar', ax=ax, alpha=0.7, color=color,
                                                             edgecolor=edgecolor)

        # 设置每个子图的标题和标签
        ax.set_title(f'{name} with {group.shape[0]} obs')
        ax.set_xlabel(xlabel)
        ax.set_ylabel('Count')

    # 隐藏多余的子图，如果 'group_names' 的数量不是4的倍数
    for i in range(len(group_names), num_rows * 4):
        axes[i].axis('off')

    # 调整布局
    plt.tight_layout()
    plt.show()

def plot_two_columns(structure_data,colname1='land_surface_condition',colname2='damage_grade'):
    # Calculate counts
    df_temp = structure_data.groupby([colname1,colname2 ]).size().reset_index(name='count')

    # Calculate Proportion of grade
    df_temp['proportion'] = df_temp.groupby(colname1)['count'].transform(lambda x: 100 * x / x.sum())

    # Plot chart
    plt.figure(figsize=(12, 5))
    ax = sns.barplot(data=df_temp,
                    x=colname1,
                    y='proportion',
                    hue=colname2)
    ax.yaxis.set_major_formatter(mtick.PercentFormatter())
    ax.legend(loc='center left', bbox_to_anchor=(1, 0.5), ncol=1)
    plt.title(f"Distribution of {convert_string(colname2)} by {convert_string(colname1)}")
    plt.xlabel(convert_string(colname1))
    plt.ylabel("Percentage of Buildings")
    plt.xticks(rotation=30)
    plt.show()
    print(structure_data[colname1].value_counts())

    # Clean up
    del df_temp, ax

def my_violinplot(structure_data,x='damage_grade',y='age_building',ylim_low=None,ylim_high=None):
    plt.figure()
    sns.violinplot(x=x, y=y, data = structure_data,inner_kws=dict(box_width=15, whis_width=2, color=".8"))
    plt.xlabel(convert_string(x))
    plt.ylabel(convert_string(y))
    plt.title("The distribution of {} v.s. {}".format(convert_string(y),convert_string(x)))
    plt.ylim(ylim_low,ylim_high)
    plt.savefig(f"{y} vs {x}.png")
    plt.show()
