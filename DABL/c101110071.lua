--ＢＦ－ツインシャドウ
function c101110071.initial_effect(c)
	aux.AddCodeList(c,9012916)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101110071+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101110071.cost)
	e1:SetTarget(c101110071.target)
	e1:SetOperation(c101110071.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c101110071.handcon)
	c:RegisterEffect(e2)
end
function c101110071.tdfilter(c)
	return c:IsSetCard(0x33) and c:IsLevelAbove(1) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeckOrExtraAsCost()
end
function c101110071.spfilter(c,e,tp,lv)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsType(TYPE_SYNCHRO) 
		and (c:IsSetCard(0x33) or c:IsCode(9012916))
		and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c101110071.rescon(sg,e,tp,mg)
	return #sg==2 and sg:FilterCount(Card.IsType,nil,TYPE_TUNER)==1
		and Duel.IsExistingMatchingCard(c101110071.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg:GetSum(Card.GetLevel))
end
function c101110071.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101110071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101110071.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c101110071.rescon,2,2,e,tp,mg) end
	local dg=g:SelectSubGroup(tp,c101110071.rescon,false,2,2,e,tp,mg)
	e:SetLabel(dg:GetSum(Card.GetLevel))
	Duel.SendtoDeck(dg,nil,2,REASON_COST)
end
function c101110071.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101110071.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then
	local tc=g:GetFirst()
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c101110071.handcon(e)
	return Duel.GetMatchingGroupCount(c101110071.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>=2
end
function c101110071.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33)
end
